# sc-adente
Shitty live coding stuff.

## Sam-ples
Retrieve samples:  
```rclone sync annoying:sam-ples ~/.sam-ples -P```

Update samples:  
```rclone sync ~/.sam-ples annoying:sam-ples -P```

### Dependencies

```cabal install bitwise``` (for bit operations)