// On-disk file system format. 
// Both the kernel and user programs use this header file.

// Block 0 is unused.
// Block 1 is super block.
// Blocks 2 through sb.ninodes/IPB hold inodes.
// Then free bitmap blocks holding sb.size bits.
// Then sb.nblocks data blocks.
// Then sb.nlog log blocks.

#define ROOTINO 1  // root i-number
#define BSIZE 512  // block size

// File system super block
struct superblock {
  uint size;         // Size of file system image (blocks)
  uint nblocks;      // Number of data blocks
  uint ninodes;      // Number of inodes.
  uint nlog;         // Number of log blocks
};

// struct of block layout of dinode
/*
      -----------------
        type  | major
      -----------------
        minor | nlink
      -----------------
            size
      -----------------  --- start of direct block ---
          addrs[0]
      -----------------
            .
            .
            .
      -----------------   
          addrs[11]
      ----------------- --- start of single-linked direct block ---
          addrs[12]
      ----------------- --- start of double-linked direct block ---
          addrs[13]
      -----------------
*/


// number of direct block
#define NDIRECT 11

// number of single-linked indirect blocks: 128
#define NINDIRECT (BSIZE / sizeof(uint))

// number of double-linked indirect blocks: 128 * 128
#define NDINDIRECT ((NINDIRECT) * (NINDIRECT))

// max file size in the size of block: direct blocks + single/double-linked
// direct blocks
#define MAXFILE (NDIRECT + NINDIRECT + NDINDIRECT)

#define SINGLE_LINKED_INDIRECT_TABLE  (NDIRECT)
#define DOUBLE_LINKED_INDIRECT_TABLE  (NDIRECT + 1)

// On-disk inode structure
struct dinode {
  short type;           // File type
  short major;          // Major device number (T_DEV only)
  short minor;          // Minor device number (T_DEV only)
  short nlink;          // Number of links to inode in file system
  uint size;            // Size of file (bytes)

  // the entry is the block number (aka. sector number)
  // it is not the acutally address
  uint addrs[NDIRECT+2];  // Data block addresses
};

// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode))

// Block containing inode i
// boot secotr --> block 0
// super block --> block 1
// so + 2
#define IBLOCK(i)     ((i) / IPB + 2)

// Bitmap bits per block
#define BPB           (BSIZE*8)

// calculate the Block number containing the bit for block b
// boot sector, super block, at least one inode block and at least
// one bitmap block, so + 3.
#define BBLOCK(b, ninodes) (b/BPB + (ninodes)/IPB + 3)

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14

// A directory is "special" kind of file, which content is struct dirent.
// In other words, the block the inode points to contains struct dirent.
//
//
// A directory is implemented internally much like a file. It has
// node type T_DIR and its data is a sequence of directory entries.
// Each entry is a struct dirent.
struct dirent {
  // if inum is 0, dirent is free
  ushort inum;          // inode number
  char name[DIRSIZ];
};

